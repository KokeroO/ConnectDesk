import * as types from '../mutation-types';
import UserGeneralPreferences from '../../api/userGeneralPreferences';

const state = {
  record: {},
  uiFlags: {
    isFetching: false,
    isUpdating: false,
  },
};

export const getters = {
  getUIFlags($state) {
    return $state.uiFlags;
  },
  getSelectedEmailFlags: $state => {
    return $state.record.selected_email_flags;
  },
  getSelectedPushFlags: $state => {
    return $state.record.selected_push_flags;
  },
};

export const actions = {
  get: async ({ commit }) => {
    commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, { isFetching: true });
    try {
      const response = await UserGeneralPreferences.get();
      commit(types.default.SET_USER_NOTIFICATION, response.data);
      commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, {
        isFetching: false,
      });
    } catch (error) {
      commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, {
        isFetching: false,
      });
    }
  },

  update: async ({ commit }, { sessionTime, activityMessageView }) => {
    commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, { isUpdating: true });
    try {
      const response = await UserGeneralPreferences.update({
        general_preferences: {
          session_time: sessionTime,
          activity_message_view: activityMessageView,
        },
      });
      commit(types.default.SET_USER_NOTIFICATION, response.data);
      commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, {
        isUpdating: false,
      });
    } catch (error) {
      commit(types.default.SET_USER_NOTIFICATION_UI_FLAG, {
        isUpdating: false,
      });
      throw error;
    }
  },
};

export const mutations = {
  [types.default.SET_USER_NOTIFICATION_UI_FLAG]($state, data) {
    $state.uiFlags = {
      ...$state.uiFlags,
      ...data,
    };
  },
  [types.default.SET_USER_NOTIFICATION]: ($state, data) => {
    $state.record = data;
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
