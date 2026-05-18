import random


class Dice:
    def __init__(self, n_sides: int, cheat_side: int, cheat_prob: float = 0.3):
        self.n_sides = n_sides
        self.cheat_side = cheat_side
        self.cheat_prob = cheat_prob

    def throw(self) -> int:
        if random.random() <= self.cheat_prob:
            return self.cheat_side
        return random.randint(1, self.n_sides)


dice = Dice(n_sides=6, cheat_side=3, cheat_prob=0)

counts = {}
for _ in range(1000):
    value = dice.throw()
    counts[value] = counts.get(value, 0) + 1

for side in sorted(counts):
    print(f"{side}: {counts[side]}")