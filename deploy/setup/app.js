const copyButton = document.querySelector("#copy-installer");
const command = document.querySelector("#install-command");
const label = document.querySelector("#copy-label");
const symbol = document.querySelector("#copy-symbol");

copyButton?.addEventListener("click", async () => {
  if (!command || !label || !symbol) return;

  try {
    await navigator.clipboard.writeText(command.textContent.trim());
    label.textContent = "Copied — paste in Terminal";
    symbol.textContent = "✓";

    window.setTimeout(() => {
      label.textContent = "Copy install command";
      symbol.textContent = "⌘";
    }, 2200);
  } catch {
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(command);
    selection.removeAllRanges();
    selection.addRange(range);
    label.textContent = "Command selected — press ⌘C";
  }
});
