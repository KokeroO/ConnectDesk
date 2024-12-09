import Auth from '../api/auth';
import {
  clearCookiesOnLogout,
  deleteIndexedDBOnLogout,
} from '../store/utils/api';

const parseErrorCode = error => {
  if (error.response && error.response.status === 401) {
    deleteIndexedDBOnLogout();
    clearCookiesOnLogout();
    window.location.assign('/app/login');
  }
  return Promise.reject(error);
};

export default axios => {
  const { apiHost = '' } = window.chatwootConfig || {};
  const wootApi = axios.create({ baseURL: `${apiHost}/` });
  // Add Auth Headers to requests if logged in
  if (Auth.hasAuthCookie()) {
    const {
      'access-token': accessToken,
      'token-type': tokenType,
      client,
      expiry,
      uid,
    } = Auth.getAuthData();
    Object.assign(wootApi.defaults.headers.common, {
      'access-token': accessToken,
      'token-type': tokenType,
      client,
      expiry,
      uid,
    });
  }
  // Response parsing interceptor
  wootApi.interceptors.response.use(
    response => {
      localStorage.setItem('last_activity_at', Date.now());
      return response;
    },
    error => parseErrorCode(error)
  );
  return wootApi;
};
