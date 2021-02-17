import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import axios from 'axios'
import VueAxios from 'vue-axios'

Vue.config.productionTip = false

Vue.use(VueRouter)
Vue.use(VueAxios, axios)
const router = new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: App },
  ]
});
new Vue({
  render: (h) => h(App),
  router
}).$mount('#app');
