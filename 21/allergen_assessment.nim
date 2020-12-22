import algorithm
import os
import strutils
import sequtils
import strformat
import sets
import tables
import sugar

import npeg

type
  Food = ref object
    ingredients: HashSet[string]
    allergens: HashSet[string]
  FoodContext = object
    foods: seq[Food]
    current: Food

proc `$`(f: Food): string =
  fmt"Food({f.ingredients}, {f.allergens})"

proc newFood(): Food =
  Food(ingredients: initHashSet[string](), allergens: initHashSet[string]())

let parser = peg("grammar", ctxt: FoodContext):
  grammar <- food * *("\n" * food)
  food <- ingredients * Space * allergens:
    var food = newFood()
    ctxt.foods.add(food)
    ctxt.current = food
  ingredients <- ingredient * *(Space * ingredient)
  allergens <- * "(contains " * allergen * *(", " * allergen) * ")"
  ingredient <- >+Alpha:
    ctxt.current.ingredients.incl($1)
  allergen <- >+Alpha:
    ctxt.current.allergens.incl($1)

var ctxt: FoodContext
ctxt.current = newFood()
ctxt.foods.add(ctxt.current)
assert parser.match(readFile(paramStr(1)), ctxt).ok

let
  allIngredients = ctxt.foods.mapIt(it.ingredients).foldl(a + b)
var
  possibleIngredients = initOrderedTable[string, HashSet[string]]()
  ingredientCounts = initCountTable[string]()

for food in ctxt.foods:
  for allergen in food.allergens:
    if not possibleIngredients.hasKey(allergen):
      possibleIngredients[allergen] = allIngredients
    possibleIngredients[allergen] = possibleIngredients[allergen] * food.ingredients
  for ingredient in food.ingredients:
    ingredientCounts.inc(ingredient)

let
  possiblyAllergenic = toSeq(possibleIngredients.values).foldl(a + b)
  notAllergenic = allIngredients - possiblyAllergenic
echo notAllergenic.mapIt(ingredientCounts[it]).foldl(a + b)

while any(toSeq(possibleIngredients.values), x => x.len > 1):
  for allergen, ingredients in possibleIngredients.pairs:
    if ingredients.len == 1:
      for otherAllergen, otherIngreds in possibleIngredients.mpairs:
        if otherAllergen != allergen:
          otherIngreds = otherIngreds - ingredients

echo toSeq(possibleIngredients.pairs).sorted.mapIt(toSeq(it[1])[0]).join(",")
