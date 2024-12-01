use std::io::Read;

#[derive(Debug)]
struct MapRange {
    dst: u64,
    src: u64,
    size: u64,
}

type Map = Vec<MapRange>;

fn part1(seeds: &Vec<u64>, maps: &Vec<Map>) -> u64 {
    seeds.iter().map(|seed| {
        let loc = maps.iter().fold(*seed, |acc, map| {
            let next = map.iter()
                .find(|r| r.src <= acc && acc < (r.src + r.size))
                .map_or(acc, |r| acc - r.src + r.dst);
            println!("\t{next}");
            next
        });
        println!("seed: {seed}, loc: {loc}");
        loc
    }).min().unwrap()
}

fn part2(seeds: &Vec<u64>, maps: &Vec<Map>) -> u64 {
    let all_seeds = seeds.chunks(2)
        .flat_map(|c| std::ops::Range { start: c[0], end: c[0] + c[1] })
        .collect::<Vec<_>>();
    part1(&all_seeds, maps)
}

fn main() {
    let mut input = String::new();
    std::io::stdin().read_to_string(&mut input).unwrap();

    let mut groups = input.split("\n\n");
    let seeds = groups.next()
        .unwrap()
        .split_whitespace()
        .skip(1)
        .map(|s| s.parse::<u64>().unwrap())
        .collect::<Vec<_>>();
    let maps = groups.map(|g| {
        g.trim()
            .split("\n")
            .skip(1)
            .map(|m| {
                let mut iter = m.trim().split_whitespace()
                    .map(|s| s.parse::<u64>().unwrap());
                MapRange {
                    dst: iter.next().unwrap(),
                    src: iter.next().unwrap(),
                    size: iter.next().unwrap(),
                }
            })
        .collect::<Map>()
    }).collect::<Vec<_>>();

    //println!("{}", part1(&seeds, &maps));
    println!("{}", part2(&seeds, &maps));
}
