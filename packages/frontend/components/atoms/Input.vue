<template>
  <div>
    <input
      type="text"
      :placeholder="placeholder"
      class="mt-1 p-2 block w-full border focus:ring-green-300 focus:border-green-300 text-xs border-gray-300 rounded-md"
      @change="onChange"
    />
  </div>
</template>

<script lang="ts">
import Vue from "vue";
export default Vue.extend({
  props: {
    placeholder: {
      type: String,
      default: null,
    },
  },
  methods: {
    onChange(e: unknown) {
      console.log("change");
      this.$emit("click", e);
    },
  },
});
</script>
