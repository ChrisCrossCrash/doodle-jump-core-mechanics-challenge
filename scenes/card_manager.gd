class_name CardManager
extends Node2D
## Responsible for all card-related features.

enum Suit { CLUBS, SPADES, HEARTS, DIAMONDS }
enum Rank {
    TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN,
    JACK, QUEEN, KING, ACE,
}
enum HandType {
    HIGH_CARD, ONE_PAIR, TWO_PAIR, THREE_OF_A_KIND, STRAIGHT, FLUSH,
    FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_FLUSH,
}


## Return the best hand type in a set of five cards.
static func get_best_hand(cards: Array[Card]) -> HandType:
    assert(cards.size() == 5, "Exactly 5 cards are required to evaluate a hand.")

    cards.sort_custom(_sort_cards)

    var suits := C3Utils.HashSet.new()
    for card in cards:
        suits.add(card.suit)

    var is_flush := suits.size() == 1

    var is_straight := true
    var lowest_card := cards[0].rank
    if lowest_card > Rank.TEN:
        is_straight = false
    else:
        for i in range(5):
            if cards[i].rank != lowest_card + i:
                is_straight = false
                continue
    # Handle the case of a wheel/bicycle hand
    var hand_ranks := _get_hand_ranks(cards)
    if hand_ranks == [Rank.TWO, Rank.THREE, Rank.FOUR, Rank.FIVE, Rank.ACE]:
        is_straight = true

    if is_straight and is_flush:
        if lowest_card == Rank.TEN:
            return HandType.ROYAL_FLUSH
        return HandType.STRAIGHT_FLUSH

    var rank_counts := _get_rank_counts(cards)

    if rank_counts[0] == 4:
        return HandType.FOUR_OF_A_KIND

    if rank_counts[0] == 3 and rank_counts[1] == 2:
        return HandType.FULL_HOUSE

    if is_flush:
        return HandType.FLUSH

    if is_straight:
        return HandType.STRAIGHT

    if rank_counts[0] == 3:
        return HandType.THREE_OF_A_KIND

    if rank_counts[0] == 2 and rank_counts[1] == 2:
        return HandType.TWO_PAIR

    if rank_counts[0] == 2:
        return HandType.ONE_PAIR

    return HandType.HIGH_CARD


static func _sort_cards(a: Card, b: Card) -> bool:
    return a.rank < b.rank


static func _get_hand_ranks(cards: Array[Card]) -> Array[Rank]:
    var hand_ranks: Array[Rank] = []
    for card in cards:
        hand_ranks.append(card.rank)
    return hand_ranks


static func _get_rank_counts(cards: Array[Card]) -> Array[int]:
    var by_rank := {}
    for card in cards:
        by_rank[card.rank] = by_rank.get(card.rank, 0) + 1
    var counts: Array[int] = []
    for v in by_rank.values():
        counts.append(v)
    counts.sort_custom(func(a: int, b: int) -> bool: return a > b)
    return counts


class Card:
    var suit: Suit
    var rank: Rank

    func _init(p_suit: Suit, p_rank: Rank) -> void:
        self.suit = p_suit
        self.rank = p_rank
