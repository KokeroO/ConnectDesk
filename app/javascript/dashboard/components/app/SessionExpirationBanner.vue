<script>
import Banner from 'dashboard/components/ui/Banner.vue';
import Auth from 'dashboard/api/auth';

export default {
  components: { Banner },
  data() {
    return {
      showBanner: false,
      remainingTime: 0,
    };
  },
  computed: {
    bannerMessage() {
      return this.$t('APP_GLOBAL.SESSION_EXPIRATION', {
        time: this.formatTime(this.remainingTime),
      });
    },
    actionButtonMessage() {
      return this.$t('APP_GLOBAL.SET_PRESENCE_SESSION');
    },
    shouldShowBanner() {
      return this.showBanner;
    },
  },
  mounted() {
    setInterval(this.checkSession, 1000); // Verifica a cada segundo
  },
  methods: {
    setPresence() {
      this.$store.dispatch('setPresenceSession');
      this.showBanner = false;
    },
    checkSession() {
      const lastActivityAt = parseInt(
        localStorage.getItem('last_activity_at'),
        10
      );
      if (!lastActivityAt) return;

      const elapsedTime = Date.now() - lastActivityAt;
      this.remainingTime = Math.max(1800000 - elapsedTime, 0);

      if (this.remainingTime <= 60000 && !this.showBanner) {
        this.showBanner = true;
      }

      if (this.remainingTime <= 0) {
        Auth.logout();
      }
    },
    renewSession() {
      this.showBanner = false;
      localStorage.setItem('last_activity_at', Date.now());
    },
    formatTime(ms) {
      const seconds = Math.floor(ms / 1000);
      const secondsRemaining = seconds % 60;
      return `${secondsRemaining}s`;
    },
  },
};
</script>

<!-- eslint-disable-next-line vue/no-root-v-if -->
<template>
  <Banner
    v-if="shouldShowBanner"
    color-scheme="primary"
    :banner-message="bannerMessage"
    :action-button-label="actionButtonMessage"
    action-button-icon="person-add"
    has-action-button
    @primary-action="setPresence"
  />
</template>
