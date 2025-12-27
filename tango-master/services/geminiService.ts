import { GoogleGenAI, Type } from "@google/genai";
import { GridState, CellValue, ConstraintType } from '../types';

// Initialize Gemini
// Note: In a real app, use a proxy or secure backend. For this demo, we use env var.
const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });

const SYSTEM_INSTRUCTION = `
You are an expert vision system designed to digitize "Tango" (Sun and Moon) logic puzzles from screenshots, specifically from the LinkedIn Tango game.
Your goal is to perfectly transcribe the 6x6 grid state.

Visual Guide for LinkedIn Tango:
- **Sun**: Typically a yellow/orange circle or sun icon.
- **Moon**: Typically a blue/grey crescent or moon icon.
- **Empty**: A blank cell (often dark grey or white background).
- **Constraints**: Small white or grey symbols located exactly on the grid lines between cells.
  - 'x' or 'X': OPPOSITE constraint (cells must be different).
  - '=' or 'equal sign': EQUAL constraint (cells must be same).
  - No symbol: NONE.

Be extremely precise with constraints. They are small and easy to miss. Distinguish them from the grid lines themselves.
`;

const PROMPT = `
Analyze the provided image of a 6x6 Tango grid.

Return a JSON object with the following structure:
1. 'cells': A 6x6 array of strings ("SUN", "MOON", "EMPTY").
   - Row 0 is the top row.
   - Col 0 is the left column.

2. 'hConstraints': A 6x5 array of strings ("EQUAL", "OPPOSITE", "NONE").
   - These are the constraints BETWEEN columns.
   - hConstraints[r][c] corresponds to the relation between cells[r][c] and cells[r][c+1].
   - There are 6 rows, each having 5 slots for horizontal constraints.

3. 'vConstraints': A 5x6 array of strings ("EQUAL", "OPPOSITE", "NONE").
   - These are the constraints BETWEEN rows.
   - vConstraints[r][c] corresponds to the relation between cells[r][c] and cells[r+1][c].
   - There are 5 rows of constraints (between the 6 rows of cells), each having 6 columns.

Verify the counts: 
- cells should have 36 entries.
- hConstraints should have 30 entries (6 rows * 5 cols).
- vConstraints should have 30 entries (5 rows * 6 cols).
`;

export const parseGridFromImage = async (base64Image: string): Promise<GridState> => {
  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: {
        parts: [
          {
            inlineData: {
              mimeType: 'image/jpeg',
              data: base64Image
            }
          },
          { text: PROMPT }
        ]
      },
      config: {
        systemInstruction: SYSTEM_INSTRUCTION,
        responseMimeType: 'application/json',
        responseSchema: {
          type: Type.OBJECT,
          properties: {
            cells: {
              type: Type.ARRAY,
              items: {
                type: Type.ARRAY,
                items: { type: Type.STRING, enum: ['SUN', 'MOON', 'EMPTY'] }
              }
            },
            hConstraints: {
              type: Type.ARRAY,
              items: {
                type: Type.ARRAY,
                items: { type: Type.STRING, enum: ['EQUAL', 'OPPOSITE', 'NONE'] }
              }
            },
            vConstraints: {
              type: Type.ARRAY,
              items: {
                type: Type.ARRAY,
                items: { type: Type.STRING, enum: ['EQUAL', 'OPPOSITE', 'NONE'] }
              }
            }
          }
        }
      }
    });

    if (!response.text) throw new Error("No response from Gemini");
    
    const rawData = JSON.parse(response.text);
    
    // Map raw strings to Enums to ensure type safety
    // Also perform basic validation on dimensions to prevent crashes
    const cells = (rawData.cells || []).slice(0, 6).map((row: string[]) => 
      (row || []).slice(0, 6).map(c => CellValue[c as keyof typeof CellValue] || CellValue.EMPTY)
    );

    // Ensure 6x6 structure for cells if incomplete
    while (cells.length < 6) cells.push(Array(6).fill(CellValue.EMPTY));
    cells.forEach(row => { while (row.length < 6) row.push(CellValue.EMPTY); });

    const hConstraints = (rawData.hConstraints || []).slice(0, 6).map((row: string[]) => 
      (row || []).slice(0, 5).map(c => ConstraintType[c as keyof typeof ConstraintType] || ConstraintType.NONE)
    );
    // Ensure 6x5
    while (hConstraints.length < 6) hConstraints.push(Array(5).fill(ConstraintType.NONE));
    hConstraints.forEach(row => { while (row.length < 5) row.push(ConstraintType.NONE); });

    const vConstraints = (rawData.vConstraints || []).slice(0, 5).map((row: string[]) => 
      (row || []).slice(0, 6).map(c => ConstraintType[c as keyof typeof ConstraintType] || ConstraintType.NONE)
    );
    // Ensure 5x6
    while (vConstraints.length < 5) vConstraints.push(Array(6).fill(ConstraintType.NONE));
    vConstraints.forEach(row => { while (row.length < 6) row.push(ConstraintType.NONE); });

    return { cells, hConstraints, vConstraints };

  } catch (error) {
    console.error("Gemini Error:", error);
    throw new Error("Failed to analyze image. Please try again.");
  }
};