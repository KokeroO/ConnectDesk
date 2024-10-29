<script setup>
<<<<<<< HEAD
import { ref, computed } from 'vue';
import { OnClickOutside } from '@vueuse/components';
=======
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useToggle } from '@vueuse/core';
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))

import CardLayout from 'dashboard/components-next/CardLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import DropdownMenu from 'dashboard/components-next/dropdown-menu/DropdownMenu.vue';

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  articlesCount: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
});

const emit = defineEmits(['click']);

const [showActionsDropdown, toggleDropdown] = useToggle();

const menuItems = [
  {
    label: 'Edit',
    action: 'edit',
<<<<<<< HEAD
    icon: 'edit',
=======
    value: 'edit',
    icon: 'i-lucide-pencil',
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
  },
  {
    label: 'Delete',
    action: 'delete',
<<<<<<< HEAD
    icon: 'delete',
=======
    value: 'delete',
    icon: 'i-lucide-trash',
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
  },
];

const description = computed(() => {
  return props.description ? props.description : 'No description added';
});

const hasDescription = computed(() => {
  return props.description.length > 0;
});

const handleClick = id => {
  emit('click', id);
};

<<<<<<< HEAD
// eslint-disable-next-line no-unused-vars
const handleAction = action => {
  // TODO: Implement action
=======
const handleAction = ({ action, value }) => {
  emit('action', { action, value, id: props.id });
  toggleDropdown(false);
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
};
</script>

<!-- TODO: Add i18n -->
<!-- eslint-disable vue/no-bare-strings-in-template -->
<template>
  <CardLayout @click="handleClick(id)">
    <template #header>
      <div class="flex gap-2">
<<<<<<< HEAD
        <div class="flex justify-between w-full">
          <div class="flex items-center justify-start gap-2">
            <span
              class="text-base cursor-pointer group-hover/cardLayout:underline text-slate-900 dark:text-slate-50 line-clamp-1"
=======
        <div class="flex justify-between w-full gap-2">
          <div class="flex items-center justify-start w-full min-w-0 gap-2">
            <span
              class="text-base truncate cursor-pointer hover:underline underline-offset-2 hover:text-n-blue-text text-n-slate-12"
              @click="handleClick(slug)"
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
            >
              {{ title }}
            </span>
            <span
<<<<<<< HEAD
              class="inline-flex items-center justify-center h-6 px-2 py-1 text-xs text-center border rounded-lg text-slate-500 w-fit border-slate-200 dark:border-slate-800 dark:text-slate-400"
=======
              class="inline-flex items-center justify-center h-6 px-2 py-1 text-xs text-center border rounded-lg bg-n-slate-1 whitespace-nowrap shrink-0 text-n-slate-11 border-n-slate-4"
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
            >
              {{ articlesCount }} articles
            </span>
          </div>
<<<<<<< HEAD
          <div class="relative group" @click.stop>
            <Button
              variant="ghost"
              size="icon"
              icon="more-vertical"
              class="w-8 z-60 group-hover:bg-slate-100 dark:group-hover:bg-slate-800"
              @click="isOpen = !isOpen"
            />
            <OnClickOutside @trigger="isOpen = false">
              <DropdownMenu
                v-if="isOpen"
                :menu-items="menuItems"
                class="right-0 mt-1 xl:left-0 top-full z-60"
                @action="handleAction"
              />
            </OnClickOutside>
=======
          <div
            v-on-clickaway="() => toggleDropdown(false)"
            class="relative group"
          >
            <Button
              icon="i-lucide-ellipsis-vertical"
              color="slate"
              size="xs"
              variant="ghost"
              class="rounded-md group-hover:bg-n-alpha-2"
              @click="toggleDropdown()"
            />
            <DropdownMenu
              v-if="showActionsDropdown"
              :menu-items="categoryMenuItems"
              class="mt-1 ltr:right-0 rtl:left-0 xl:ltr:left-0 xl:rtl:right-0 top-full z-60"
              @action="handleAction"
            />
>>>>>>> aa57431c4 (fix: Dropdown menu issues (#10364))
          </div>
        </div>
      </div>
    </template>
    <template #footer>
      <span
        class="text-sm line-clamp-3"
        :class="
          hasDescription
            ? 'text-slate-500 dark:text-slate-400'
            : 'text-slate-400 dark:text-slate-700'
        "
      >
        {{ description }}
      </span>
    </template>
  </CardLayout>
</template>
