export const sleep = async (milliseconds = 1000) => new Promise(resolve => setTimeout(resolve, milliseconds)) 

export const clearNLines = (nLines = 1) => {
  for (let index = 0; index < nLines; index++) {
    process.stdout.write('\x1b[1A'); // Move cursor up one line
    process.stdout.write('\x1b[2K'); // Clear the line
  }
}
