import Vue from 'vue'
import Router from 'vue-router'
import CreateComponent from '@/components/CreateComponent'
import SearchComponent from '@/components/SearchComponent'
import SelectComponent from '@/components/SelectComponent'
import VueGoodTable from 'vue-good-table'

Vue.use(Router)
Vue.use(VueGoodTable)

export default new Router({
  routes: [
    {
      path: '/',
      component: SearchComponent
    },
    {
      path: '/createStation',
      component: CreateComponent
    },
    {
      path: '/selectStation/:id',
      component: SelectComponent
    } 
  ]
})
