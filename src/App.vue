<template>
  <div id="app">
    <h1 class="title">Solita Pizza Maker</h1>
    <div class="box">
      <div class="left-container">
        <div class="option">{{ topping }}?</div>
        <div class="option-container">
          <div v-if="showSauceCan" class="sauce-can">
            <div class="top-rim"></div>
            <div class="bottom-rim"></div>
            <div class="red-label"></div>
            <div class="badge"></div>
          </div>
          <div v-if="showShreddedCheese" class="shredded-cheese-wedge">
            <div class="wedge-circle-1"></div>
            <div class="wedge-circle-2"></div>
            <div class="wedge-circle-3"></div>
          </div>
          <div v-if="showMozzarellaCheese" class="moz-wedge"></div>
          <div v-if="showPepperoniTopping" class="pep-option"></div>
        </div>
        <div v-if="buttonsOn" @click="processInput(1)" class="yes-button">YES</div>
        <div v-if="buttonsOn" @click="processInput(2)" class="no-button">NO</div>
      </div>
      <div class="right-container">
        <div class="option">
          <span id="white">{{ totalCost }}</span>
        </div>
        <div :class="pizzaClass">
          <div v-if="showSauce" class="sauce"></div>
          <div v-if="showWedgeCheese" class="wedge-cheese">
            <div class="cheese-1"></div>
            <div class="cheese-2"></div>
            <div class="cheese-3"></div>
          </div>
          <div v-if="showStringCheese" class="string-cheese"></div>
          <div v-if="showPepperoni" class="pepperoni">
            <div class="pepperoni-1"></div>
            <div class="pepperoni-2"></div>
            <div class="pepperoni-3"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from "vue";

//left container
const topping = ref("Sauce");

const buttonsOn = ref(true);
const showSauceCan = ref(true);
const showShreddedCheese = ref(false);
const showMozzarellaCheese = ref(false);
const showPepperoniTopping = ref(false);

//right container
let pizzaClass = "pizza";
const showSauce = ref(false);
const showWedgeCheese = ref(false);
const showStringCheese = ref(false);
const showPepperoni = ref(false);
const currentPrice = ref(0);
const totalCost = ref("$0");

const prices = reactive([2, 2, 3, 3, 3]);

//count which option we are on
let stage = 1;

function processInput(selection) {
  if (selection === 1) {
    //yes button clicked and do stuff accordingly
    if (stage === 1) {
      showSauce.value = true;
    } else if (stage === 2) {
      showStringCheese.value = true;
    } else if (stage === 3) {
      showWedgeCheese.value = true;
    } else if (stage === 4) {
      showPepperoni.value = true;
    }

    if (stage !== 5) {
      currentPrice.value += prices[stage - 1];
      totalCost.value = "$" + currentPrice;
    }
  } else if (selection === 2) {
    //do nothing
  }
  if (stage === 1) {
    showSauceCan.value = false;
    showShreddedCheese.value = true;
    topping.value = "Shredded Cheese";
  } else if (stage === 2) {
    showShreddedCheese.value = false;
    showMozzarellaCheese.value = true;
    topping.value = "Mozzarella Cheese";
  } else if (stage === 3) {
    showMozzarellaCheese.value = false;
    showPepperoniTopping.value = true;
    topping.value = "Pepperoni";
  } else if (stage === 4) {
    showPepperoniTopping.value = false;
    topping.value = "Order";
    pizzaClass = "spin-pizza";
  } else if (stage === 5) {
    buttonsOn.value = false;
    topping.value = "Out of Order";
  }
  stage++;
}
</script>
