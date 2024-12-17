<script>
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';
import { useUISettings } from 'dashboard/composables/useUISettings';
import {
  hasPushPermissions,
  requestPushPermissions,
  verifyServiceWorkerExistence,
} from 'dashboard/helper/pushHelper.js';
import FormSwitch from 'v3/components/Form/Switch.vue';
import GeneralPreferencesSession from './GeneralPreferencesSession.vue';

export default {
  components: {
    FormSwitch,
    GeneralPreferencesSession,
  },
  setup() {
    const { uiSettings, updateUISettings } = useUISettings();

    return {
      uiSettings,
      updateUISettings,
    };
  },
  data() {
    return {
      activityMessageView: this.uiSettings.activity_message_view,
      sessionTime: this.uiSettings.session_time,
    };
  },
  computed: {
    ...mapGetters({
      emailFlags: 'userNotificationSettings/getSelectedEmailFlags',
      pushFlags: 'userNotificationSettings/getSelectedPushFlags',
    }),
    hasPushAPISupport() {
      return !!('Notification' in window);
    },
  },
  watch: {
    emailFlags(value) {
      this.selectedEmailFlags = value;
    },
    pushFlags(value) {
      this.selectedPushFlags = value;
    },
  },
  mounted() {
    if (hasPushPermissions()) {
      this.getPushSubscription();
    }
    this.$store.dispatch('userNotificationSettings/get');
  },
  methods: {
    checkFlagStatus(type, flagType) {
      const selectedFlags =
        type === 'email' ? this.selectedEmailFlags : this.selectedPushFlags;
      return selectedFlags.includes(`${type}_${flagType}`);
    },
    onRegistrationSuccess() {
      this.hasActivityMessageView = true;
    },
    onRequestPermissions() {
      requestPushPermissions({
        onSuccess: this.onRegistrationSuccess,
      });
    },
    getPushSubscription() {
      verifyServiceWorkerExistence(registration =>
        registration.pushManager
          .getSubscription()
          .then(subscription => {
            if (!subscription) {
              this.hasEnabledPushPermissions = false;
            } else {
              this.hasEnabledPushPermissions = true;
            }
          })
          // eslint-disable-next-line no-console
          .catch(error => console.log(error))
      );
    },
    async updateGeneralSettings() {
      try {
        this.$store.dispatch('userGeneralSettings/update', {
          sessionTime: this.sessionTime,
          activityMessageView: this.activityMessageView,
        });
        useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_SUCCESS'));
      } catch (error) {
        useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_ERROR'));
      }
    },
    handleInput(type, id) {
      this.handlePushInput(id);
    },
    handlePushInput(id) {
      this.selectedPushFlags = this.toggleInput(this.selectedPushFlags, id);
      this.updateNotificationSettings();
    },
    toggleInput(selected, current) {
      if (selected.includes(current)) {
        const newSelectedFlags = selected.filter(flag => flag !== current);
        return newSelectedFlags;
      }
      return [...selected, current];
    },
    sessionTimeChange(value) {
      this.sessionTime = value;
      this.updateUISettings({
        session_time: this.sessionTime,
      });
      useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_SUCCESS'));
    },
    activityMessageViewChange(value) {
      this.activityMessageView = value;
      this.updateUISettings({
        activity_message_view: this.activityMessageView,
      });
      useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_SUCCESS'));
    },
  },
};
</script>

<template>
  <div id="profile-general-preferences" class="flex flex-col gap-6">
    <GeneralPreferencesSession
      :label="
        $t('PROFILE_SETTINGS.FORM.GENERAL_PREFERENCES_SECTION.SESSION.TITLE')
      "
      :value="sessionTime"
      @update="sessionTimeChange"
    />
    <div
      class="flex items-center justify-between w-full gap-2 p-4 border border-solid border-ash-200 rounded-xl"
    >
      <div class="flex flex-row items-center gap-2">
        <fluent-icon
          icon="block"
          class="flex-shrink-0 text-ash-900"
          size="18"
        />
        <span class="text-sm text-ash-900">
          {{
            $t(
              'PROFILE_SETTINGS.FORM.GENERAL_PREFERENCES_SECTION.ACTIVITY_MESSAGE'
            )
          }}
        </span>
      </div>
      <FormSwitch
        :model-value="activityMessageView"
        @update:model-value="activityMessageViewChange"
      />
    </div>
  </div>
</template>
