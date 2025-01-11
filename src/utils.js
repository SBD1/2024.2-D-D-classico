import chalk from "chalk";

export const sleep = async (milliseconds = 1000) => new Promise(resolve => setTimeout(resolve, milliseconds)) 

export const clearNLines = (nLines = 1) => {
  for (let index = 0; index < nLines; index++) {
    process.stdout.write('\x1b[1A'); // Move cursor up one line
    process.stdout.write('\x1b[2K'); // Clear the line
  }
}

export const createProgressBar = (total, barLength, sucessMsg) => {
  let current = 0;

  function update() {
    const percentage = (current / total) * 100;
    const barLengthToUse = barLength ?? 30; // Length of the progress bar
    const filledLength = Math.round((barLengthToUse * current) / total);
    const bar = '='.repeat(filledLength) + '-'.repeat(barLengthToUse - filledLength);

    clearNLines()
    if (percentage === 100) {
      console.log(chalk.green(`[${bar}] ${percentage.toFixed(2)}%${sucessMsg??''}`));
    } else {
      console.log(`[${bar}] ${percentage.toFixed(2)}%`);
    }
  }

  function showError() {
    const percentage = (current / total) * 100;
    const barLengthToUse = barLength ?? 30; // Length of the progress bar
    const filledLength = Math.round((barLengthToUse * current) / total);
    const bar = '='.repeat(filledLength) + '-'.repeat(barLengthToUse - filledLength);

    clearNLines()
    console.log(chalk.red(`[${bar}] ${percentage.toFixed(2)}% X`));

  }

  return {
    increment: (value = 1) => {
      current = Math.min(current + value, total);
      update();
      return current;
    },
    showError,
    reset: () => {
      current = 0;
      update();
    },
  };
}

