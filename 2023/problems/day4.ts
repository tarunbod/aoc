const lines = [];
for await (const line of console) {
  if (line == "") break;
  lines.push(line);
}

const numWinning = lines.map(line => {
  const colonIdx = line.indexOf(":");
  line = line.substring(colonIdx + 2);
  const [part1, part2] = line.split(" | ");
  const winning = part1.trim().split(/\s+/).map(n => parseInt(n));
  const numWinning = part2.trim().split(/\s+/).filter(n => winning.includes(parseInt(n))).length;
  return numWinning;
});

function part1() {
  const points = numWinning.map(n => n == 0 ? 0 : Math.pow(2, n - 1)).reduce((a, b) => a + b, 0);
  console.log(points);
}

function part2() {
  console.log(numWinning, "\n");
  let cum = new Array(lines.length).fill(1);
  console.log(cum);
  for (let i = 0; i < numWinning.length; i++) {
    for (let j = 1; j <= numWinning[i]; j++) {
      cum[i + j] += cum[i];
    }
    console.log(cum);
  }
  console.log(cum.reduce((a, b) => a + b, 0));
}

part1();
part2();
