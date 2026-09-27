import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.Tactic.Push
import Mathlib.Tactic.Tauto

open Nat

theorem infinitude_of_primes :
    ∀ (n : ℕ), ∃ (p : ℕ), p.Prime ∧ p ≥ n := by
  intro n
  -- Suppose for the sake of contradiction that every prime is < n
  by_contra no_more_primes
  push Not at no_more_primes
  -- Define x = n! + 1, and find a prime divisor
  let x := n ! + 1
  let p := minFac x
  have prime_p : p.Prime := by
    apply minFac_prime
    apply x.ne_of_gt
    simp only [x, Nat.lt_add_left_iff_pos]
    apply factorial_pos
  -- Now, we have (p ∣ n!)...
  have H : p ∣ n ! := by
    apply Nat.dvd_factorial
    · apply Nat.Prime.pos
      assumption
    · apply Nat.le_of_lt
      tauto
  -- Where is our contradiction?
  suffices div1_p : p ∣ 1 by apply prime_p.not_dvd_one; trivial
  apply (Nat.dvd_add_iff_right _).2
  · apply Nat.minFac_dvd
  · assumption
