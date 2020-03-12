library("shiny")

introduction <- fluidPage(
  titlePanel("The Spread of COVIS-19 and Its Effect on Economy"),
  h1(em("Background")),
  p("Recently, influenced by COVIS-19 pneumonia, 
  Chinese state-backed importers of natural gas are examining 
  if they can provisionally halt contracts for the supercooled fuel, 
  as the COVIS-19 outbreak depresses energy demand in the world’s second-largest economy. 
  This temporary cancellation of contracts has created headaches for natural gas suppliers 
  and made them concerned about the future.",
    "Since natural gas is one of the three most important fossil fuels, 
    the natural gas market could have a large impact on the global economy. 
    In addition, stock market is also a great indicator of the global economy. 
    Therefore, our group will discuss the correlation between the spreading of COVIS-19 
    and two important economic indicators, 
    price of natural gas and NBEV stock, 
    in the final project. 
    NBEV stock is an important but relatively risky stock 
    which could reflect the stability of the stock market. 
    If the price of NBEV goes down, 
    it’s probably because investors become concerned about 
    the future economy in the short run.")
)
  