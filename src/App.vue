<template>
  <div id="app">
    <h1 class="title">Solita Pizza Maker</h1>
    <div class="box">
      <div class="left-container">
        <div class="option">{{ pizza.topping }} ?</div>
        <div class="option-container">
          <div v-if="pizza.showSauceCan" class="sauce-can">
            <div class="top-rim"></div>
            <div class="bottom-rim"></div>
            <div class="red-label"></div>
            <div class="badge"></div>
          </div>
          <div v-if="pizza.showShreddedCheese" class="shredded-cheese-wedge">
            <div class="wedge-circle-1"></div>
            <div class="wedge-circle-2"></div>
            <div class="wedge-circle-3"></div>
          </div>
          <div v-if="pizza.showMozzarellaCheese" class="moz-wedge"></div>
          <div v-if="pizza.showPepperoniTopping" class="pep-option"></div>
        </div>
        <div v-if="buttonsOn" @click="processInput(1)" class="yes-button">YES</div>
        <div v-if="buttonsOn && !resetButton" @click="processInput(2)" class="no-button">NO</div>
      </div>
      <div class="right-container">
        <div class="option">
          <span id="white">{{ totalCost }}</span>
        </div>
        <div :class="pizzaClass">
          <div v-if="pizza.showSauce" class="sauce"></div>
          <div v-if="pizza.showWedgeCheese" class="wedge-cheese">
            <div class="cheese-1"></div>
            <div class="cheese-2"></div>
            <div class="cheese-3"></div>
          </div>
          <div v-if="pizza.showStringCheese" class="string-cheese"></div>
          <div v-if="pizza.showPepperoni" class="pepperoni">
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
import axios from "axios";
import { ref, reactive } from "vue";
import { APIM_LOGIC_URL, APIM_SUBSCRIPTION_KEY } from "./config.js";

//left container
let stage = 1;
let choices = [];
let pizzaClass = ref("pizza");
const totalCost = ref("$0");
const buttonsOn = ref(true);
const resetButton = ref(false);
const currentPrice = ref(0);
const prices = reactive([2, 2, 3, 3, 3]);

let pizza = reactive({
  topping: "Sauce",
  showSauce: false,
  showWedgeCheese: false,
  showStringCheese: false,
  showPepperoni: false,
  showSauceCan: true,
  showShreddedCheese: false,
  showMozzarellaCheese: false,
  showPepperoniTopping: false,
});

async function processInput(selection) {
  if (selection === 1) {
    //yes button clicked and do stuff accordingly
    if (stage === 1) {
      pizza.showSauce = true;
      choices.push("Tomato Sauce");
    } else if (stage === 2) {
      pizza.showStringCheese = true;
      choices.push("Shredded Cheese");
    } else if (stage === 3) {
      pizza.showWedgeCheese = true;
      choices.push("Mozzarella Cheese");
    } else if (stage === 4) {
      pizza.showPepperoni = true;
      choices.push("Pepperoni");
    }

    if (stage !== 5) {
      currentPrice.value += prices[stage - 1];
      totalCost.value = "$" + currentPrice.value;
    }
  } else if (selection === 2) {
    //do nothing
  }

  if (stage === 1) {
    pizza.showSauceCan = false;
    pizza.showShreddedCheese = true;
    pizza.topping = "Shredded Cheese";
  } else if (stage === 2) {
    pizza.showShreddedCheese = false;
    pizza.showMozzarellaCheese = true;
    pizza.topping = "Mozzarella Cheese";
  } else if (stage === 3) {
    pizza.showMozzarellaCheese = false;
    pizza.showPepperoniTopping = true;
    pizza.topping = "Pepperoni";
  } else if (stage === 4) {
    pizza.showPepperoniTopping = false;
    pizza.topping = "Order";
    resetButton.value = true;
    pizzaClass.value = "spin-pizza";
  } else if (stage === 5) {
    await finishPurchase();
    resetOrder();
  }
  stage++;
}

function resetOrder() {
  alert("Pizza is ordered !");
  window.location.reload();
}

async function finishPurchase() {
  await axios.post(
    APIM_LOGIC_URL,
    {
      text: "🍕 A new order for Pizza has arrived !",
      choices,
      price: totalCost.value,
    },
    {
      headers: {
        "Ocp-Apim-Subscription-Key": APIM_SUBSCRIPTION_KEY,
      },
    }
  );
}
</script>
