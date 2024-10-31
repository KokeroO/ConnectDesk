<script setup>
import { nextTick, ref, computed, watch } from 'vue';
import { onClickOutside } from '@vueuse/core';
import { useI18n } from 'vue-i18n';
import FluentIcon from 'shared/components/FluentIcon/DashboardIcon.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import ComboBoxDropdown from 'dashboard/components-next/combobox/ComboBoxDropdown.vue';

const props = defineProps({
  options: {
    type: Array,
    required: true,
    validator: value =>
      value.every(option => 'value' in option && 'label' in option),
  },
  placeholder: {
    type: String,
    default: '',
  },
  modelValue: {
    type: [String, Number],
    default: '',
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  searchPlaceholder: {
    type: String,
    default: '',
  },
  emptyState: {
    type: String,
    default: '',
  },
  message: {
    type: String,
    default: '',
  },
  hasError: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['update:modelValue']);

const { t } = useI18n();

const selectedValue = ref(props.modelValue);
const open = ref(false);
const search = ref('');
const dropdownRef = ref(null);
const comboboxRef = ref(null);

const filteredOptions = computed(() => {
  const searchTerm = search.value.toLowerCase();
  return props.options.filter(option =>
    option.label.toLowerCase().includes(searchTerm)
  );
});
const selectPlaceholder = computed(() => {
  return props.placeholder || t('COMBOBOX.PLACEHOLDER');
});
const selectedLabel = computed(() => {
  const selected = props.options.find(
    option => option.value === selectedValue.value
  );
  return selected?.label ?? selectPlaceholder.value;
});

const selectOption = option => {
  selectedValue.value = option.value;
  emit('update:modelValue', option.value);
  open.value = false;
  search.value = '';
};

const toggleDropdown = () => {
  if (props.disabled) return;
  open.value = !open.value;
  if (open.value) {
    search.value = '';
    nextTick(() => dropdownRef.value?.focus());
  }
};

watch(
  () => props.modelValue,
  newValue => {
    selectedValue.value = newValue;
  }
);

onClickOutside(comboboxRef, () => {
  open.value = false;
});
</script>

<template>
  <div
    ref="comboboxRef"
    class="relative w-full"
    :class="{
      'cursor-not-allowed': disabled,
      'group/combobox': !disabled,
    }"
    @click.prevent
  >
    <Button
      variant="outline"
      :label="selectedLabel"
      icon-position="right"
      size="sm"
      :disabled="disabled"
      class="justify-between w-full text-slate-900 dark:text-slate-100 group-hover/combobox:border-slate-300 dark:group-hover/combobox:border-slate-600"
      :icon="open ? 'chevron-up' : 'chevron-down'"
      @click="toggleDropdown"
    />
    <div
      v-show="open"
      class="absolute z-50 w-full mt-1 transition-opacity duration-200 bg-white border rounded-md shadow-lg border-slate-200 dark:bg-slate-900 dark:border-slate-700/50"
    >
      <div class="relative border-b border-slate-100 dark:border-slate-700/50">
        <FluentIcon
          icon="search"
          :size="14"
          class="absolute text-gray-400 dark:text-slate-500 top-3 left-3"
          aria-hidden="true"
        />
        <input
          ref="searchInput"
          v-model="search"
          type="search"
          :placeholder="searchPlaceholder || t('COMBOBOX.SEARCH_PLACEHOLDER')"
          class="w-full py-2 pl-10 pr-2 text-sm bg-white border-none rounded-t-md dark:bg-slate-900 text-slate-900 dark:text-slate-50"
        />
    <OnClickOutside @trigger="open = false">
      <Button
        variant="outline"
        :color="hasError && !open ? 'ruby' : open ? 'blue' : 'slate'"
        :label="selectedLabel"
        trailing-icon
        :disabled="disabled"
        class="justify-between w-full !px-3 !py-2.5 text-n-slate-12 font-normal group-hover/combobox:border-n-slate-6"
        :class="{ focused: open }"
        :icon="open ? 'i-lucide-chevron-up' : 'i-lucide-chevron-down'"
        @click="toggleDropdown"
      />
      <ComboBoxDropdown
        ref="dropdownRef"
            :open="open"
        :options="filteredOptions"
        :search-value="search"
        :search-placeholder="searchPlaceholder"
        :empty-state="emptyState"
        :selected-values="selectedValue"
        @update:search-value="search = $event"
        @select="selectOption"
      />

      <p
        v-if="message"
        class="mt-2 mb-0 text-xs truncate transition-all duration-500 ease-in-out"
        :class="{
          'text-n-ruby-9': hasError,
          'text-n-slate-11': !hasError,
        }"
      >
        {{ message }}
      </p>
    </OnClickOutside>
  </div>
</div></div></template>
