use std::cmp::Ordering;
use std::io::Read;
use std::str::FromStr;

#[derive(Clone, Debug, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

#[derive(Clone, Debug, Eq)]
struct Hand {
    cards: [u8; 5],
    ty: HandType,
    bid: u32,
}

#[derive(Debug)]
struct ParseHandError;

impl Hand {
    fn joker_maxx(&mut self) {
        use HandType::*;
        let mut joker_count = 0;
        self.cards.iter_mut().for_each(|c| {
            if *c == 10 {
                joker_count += 1;
                *c = 0;
            }
        });
        self.ty = match (joker_count, &self.ty) {
            (4, _) => FiveOfAKind,

            (3, FullHouse) => FiveOfAKind,
            (3, ThreeOfAKind) => FourOfAKind,

            (2, FullHouse) => FiveOfAKind,
            (2, TwoPair) => FourOfAKind,
            (2, OnePair) => ThreeOfAKind,

            (1, FourOfAKind) => FiveOfAKind,
            (1, ThreeOfAKind) => FourOfAKind,
            (1, TwoPair) => FullHouse,
            (1, OnePair) => ThreeOfAKind,
            (1, HighCard) => OnePair,

            _ => return,
        };
    }
}

impl FromStr for Hand {
    type Err = ParseHandError;
    fn from_str(line: &str) -> Result<Self, Self::Err> {
        let mut parts = line.split_whitespace();
        let hand = parts.next().ok_or(ParseHandError)?;
        let bid = parts.next().ok_or(ParseHandError)?.parse::<u32>().or(Err(ParseHandError))?;

        let mut cards = [0; 5];
        let mut kind_counts = [0; 14];
        for (i, c) in hand.chars().enumerate() {
            let val = match c {
                'A' => 13,
                'T' => 9,
                'J' => 10,
                'Q' => 11,
                'K' => 12,
                _ => c.to_digit(10).ok_or(ParseHandError)? as u8 - 1,
            };
            cards[i] = val;
            kind_counts[val as usize] += 1;
        }
        let ty = if kind_counts.iter().any(|&c| c == 5) {
            HandType::FiveOfAKind
        } else if kind_counts.iter().any(|&c| c == 4) {
            HandType::FourOfAKind
        } else if kind_counts.iter().any(|&c| c == 3) {
            if kind_counts.iter().any(|&c| c == 2) {
                HandType::FullHouse
            } else {
                HandType::ThreeOfAKind
            }
        } else if kind_counts.iter().filter(|&&c| c == 2).count() == 2 {
            HandType::TwoPair
        } else if kind_counts.iter().any(|&c| c == 2) {
            HandType::OnePair
        } else {
            HandType::HighCard
        };
        Ok(Hand { cards, ty, bid })
    }
}

impl PartialEq for Hand {
    fn eq(&self, other: &Hand) -> bool {
        self.ty == other.ty && self.cards == other.cards
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Hand) -> Ordering {
        match self.ty.cmp(&other.ty) {
            Ordering::Equal => self.cards.cmp(&other.cards),
            c => c
        }
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Hand) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn part1(mut hand_bids: Vec<Hand>) -> u32 {
    hand_bids.sort();
    hand_bids.iter()
        .enumerate()
        .map(|(i, h)| h.bid * (i + 1) as u32)
        .sum()
}

fn part2(mut hand_bids: Vec<Hand>) -> u32 {
    hand_bids.iter_mut().for_each(Hand::joker_maxx);
    part1(hand_bids)
}

fn main() {
    let mut input = String::new();
    std::io::stdin().read_to_string(&mut input).unwrap();
    let hand_bids = input.trim()
        .split('\n')
        .map(|l| l.parse::<Hand>().unwrap())
        .collect::<Vec<_>>();
    println!("{:?}", part1(hand_bids.clone()));
    println!("{:?}", part2(hand_bids));
}
