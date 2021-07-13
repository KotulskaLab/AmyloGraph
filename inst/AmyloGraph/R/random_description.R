random_description <- function(id) {
  glue::glue(sample(c(
    "In my opinion, it is not that it is good or that it is not good. If I had to say what I value most in life, I would say Protein {id}. Erm... Protein {id} who gave me a helping hand when I wasn't coping, when I was alone. And interestingly enough, it's the chance encounters that influence our lives. The thing is that when you have certain values, even seemingly universal ones, you don't find the understanding, so to speak, that helps you grow. I was lucky, so to speak, because I found it. And I thank life. I thank it, life is singing, life is dancing, life is love. Many people ask me the same thing, but how do you do it, where do you get this joy? And I answer that it is simple, it is the love of life that makes me build machines today, for example, and tomorrow.... who knows why not, I'll do some social work and just plant... I mean... carrots.",
    "May the Protein {id} be with you.",
    "My mama always said Protein {id} was like a box of chocolates. You never know what you're gonna get.",
    "Keep your friends close, but your Protein {id} closer.",
    "My name is {id}. Protein {id}",
    "They may take our lives, but they'll never take our Protein {id}!",
    "- Protein {id} is like... like an onion.<br/>- (sniff, sniff) Stinks? <br/>- Yes... No!\n- It makes you cry?<br/>- No!<br/> -Sooo when you left it in the sun it turns brown and grows hair?<br/>- No! Layers! Onion has layers! Protein {id} has layers!"
  ), size = 1))
}
