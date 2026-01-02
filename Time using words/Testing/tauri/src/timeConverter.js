const numberWords = {
    0: 'zero', 1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
    6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
    11: 'eleven', 12: 'twelve', 13: 'thirteen', 14: 'fourteen', 15: 'fifteen',
    16: 'sixteen', 17: 'seventeen', 18: 'eighteen', 19: 'nineteen', 20: 'twenty',
    30: 'thirty', 40: 'forty', 50: 'fifty'
};

const hourWords = {
    1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
    6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten',
    11: 'eleven', 12: 'twelve'
};

function getHourWord(hour) {
    const h = hour === 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return hourWords[h];
}

function getMinuteWord(minutes) {
    if (minutes === 0) return '';
    if (minutes < 20) return numberWords[minutes];
    if (minutes < 30) {
        const tens = Math.floor(minutes / 10) * 10;
        const ones = minutes % 10;
        return ones === 0 ? numberWords[tens] : `${numberWords[tens]}-${numberWords[ones]}`;
    }
    if (minutes === 30) return 'thirty';
    if (minutes < 40) {
        const tens = Math.floor(minutes / 10) * 10;
        const ones = minutes % 10;
        return ones === 0 ? numberWords[tens] : `${numberWords[tens]}-${numberWords[ones]}`;
    }
    if (minutes < 50) {
        const tens = Math.floor(minutes / 10) * 10;
        const ones = minutes % 10;
        return ones === 0 ? numberWords[tens] : `${numberWords[tens]}-${numberWords[ones]}`;
    }
    const tens = Math.floor(minutes / 10) * 10;
    const ones = minutes % 10;
    return ones === 0 ? numberWords[tens] : `${numberWords[tens]}-${numberWords[ones]}`;
}

function getMinutesToWord(minutes) {
    const remaining = 60 - minutes;
    if (remaining < 20) return numberWords[remaining];
    const tens = Math.floor(remaining / 10) * 10;
    const ones = remaining % 10;
    return ones === 0 ? numberWords[tens] : `${numberWords[tens]}-${numberWords[ones]}`;
}

function timeToWordsNumeric(hour, minutes) {
    const hourWord = getHourWord(hour);
    
    if (minutes === 0) {
        return `${hourWord.charAt(0).toUpperCase() + hourWord.slice(1)} o'clock`;
    }
    
    const minuteWord = getMinuteWord(minutes);
    const formattedMinute = minutes < 10 ? `oh ${minuteWord}` : minuteWord;
    
    return `${hourWord.charAt(0).toUpperCase() + hourWord.slice(1)} ${formattedMinute}`;
}

function timeToWordsNatural(hour, minutes) {
    const hourWord = getHourWord(hour);
    const nextHourWord = getHourWord(hour + 1);
    
    if (minutes === 0) {
        return `${hourWord.charAt(0).toUpperCase() + hourWord.slice(1)} o'clock`;
    } else if (minutes === 15) {
        return `A quarter past ${hourWord}`;
    } else if (minutes === 30) {
        return `Half past ${hourWord}`;
    } else if (minutes === 45) {
        return `A quarter to ${nextHourWord}`;
    } else if (minutes < 30) {
        const minuteWord = getMinuteWord(minutes);
        return `${minuteWord.charAt(0).toUpperCase() + minuteWord.slice(1)} past ${hourWord}`;
    } else {
        const minutesTo = getMinutesToWord(minutes);
        return `${minutesTo.charAt(0).toUpperCase() + minutesTo.slice(1)} to ${nextHourWord}`;
    }
}

export function convertTimeToWords(hour, minutes, format = 'numeric') {
    if (format === 'natural') {
        return timeToWordsNatural(hour, minutes);
    } else {
        return timeToWordsNumeric(hour, minutes);
    }
}

