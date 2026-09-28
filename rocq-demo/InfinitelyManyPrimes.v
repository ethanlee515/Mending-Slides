(** * Rocq demo: infinitude of primes

    For every natural number [n], there is a prime [p > n].
    We follow Euclid's factorial-plus-one argument, using MathComp for
    elementary arithmetic facts. *)

From mathcomp Require Import ssreflect ssrfun ssrbool eqtype ssrnat div prime.

Local Notation "n !" := (factorial n) (at level 1, format "n !").

Theorem infinitude_of_primes :
  forall n : nat, exists p : nat, prime p /\ n < p.
Proof.
  (* Fix the proposed bound n. *)
  intro n.
  (* Choose a prime divisor of x = n! + 1. *)
  pose x := n ! + 1.
  have x_gt1 : 1 < x by rewrite /x addn1 ltnS fact_gt0.
  have [p prime_p p_divides_x] := pdivP x_gt1.
  exists p; split; first exact prime_p.

  (* Suppose, for contradiction, that p <= n. *)
  rewrite ltnNge; apply/negP; intro p_le_n.
  (* Then p divides n!, and hence also divides 1. *)
  have p_divides_factorial : p %| n !.
    apply dvdn_fact.
    by rewrite (prime_gt0 prime_p) p_le_n.
  have p_divides_one : p %| 1.
    by move: p_divides_x; rewrite /x (dvdn_addr _ p_divides_factorial).

  (* A prime cannot divide 1. *)
  have p_not_divides_one : (p %| 1) = false.
    by apply gtnNdvd; [| exact: prime_gt1 prime_p].
  by move: p_divides_one; rewrite p_not_divides_one.
Qed.

Print Assumptions infinitude_of_primes.
