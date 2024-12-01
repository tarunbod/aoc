const lines = [];
for await (const line of console) {
  lines.push(line);
}
lines.pop();

const directions = lines[0];

const nodeLines = lines.splice(2);
const nodes: { [key: string]: { right: string, left: string } } = {};
for (const line of nodeLines) {
  let [name, _, left, right] = line.split(" ");
  left = left.substring(1, left.length - 1);
  right = right.substring(0, right.length - 1);
  nodes[name] = { right, left };
}

function part1() {
  let dirIdx = 0;
  let steps = 0;
  let currentNode = "AAA";
  while (true) {
    steps++;
    if (directions[dirIdx] === "R") {
      currentNode = nodes[currentNode].right;
    } else {
      currentNode = nodes[currentNode].left;
    }
    dirIdx++;
    dirIdx %= directions.length;
    if (currentNode === "ZZZ") {
      break;
    }
  }
  console.log(steps);
}

function lcm(nums: number[]) {
  let lcm = nums[0];
  for (let i = 1; i < nums.length; i++) {
    let num = nums[i];
    let gcd = 1;
    for (let j = 1; j <= num && j <= lcm; j++) {
      if (num % j === 0 && lcm % j === 0) {
        gcd = j;
      }
    }
    lcm = (lcm * num) / gcd;
  }
  return lcm;
}

function part2() {
  let currentNodes = Object.keys(nodes).filter(key => key.endsWith("A"));
  let stepsArr = [];
  for (let i = 0; i < currentNodes.length; i++) {
    let currentNode = currentNodes[i];
    let dirIdx = 0;
    let steps = 0;
    while (true) {
      steps++;
      if (directions[dirIdx] === "R") {
        currentNode = nodes[currentNode].right;
      } else {
        currentNode = nodes[currentNode].left;
      }
      dirIdx++;
      dirIdx %= directions.length;
      if (currentNode.endsWith("Z")) {
        break;
      }
    }
    stepsArr.push(steps);
  }
  console.log(lcm(stepsArr));
}

part1();
part2();
