import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import SomethingElse from '@/components/SomethingElse'
import PasswordGenerator from '@/components/PasswordGenerator'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    {
      path: '/something-else',
      name: 'SomethingElse',
      component: SomethingElse
    },
    {
      path: '/password-generator',
      name: 'PasswordGenerator',
      component: PasswordGenerator
    }
  ]
})
