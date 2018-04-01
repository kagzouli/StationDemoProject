import axios from 'axios'

import CreateComponent from '@/components/CreateComponent/index.vue'

export default {
  name: 'search-component',
  components: { CreateComponent },
  props: [],
  data () {
    
    return {
      //reseau: 'RER', 
      reseau: '',           
      station: '',
      trafficMin: '',
      trafficMax: '',
      ville: '',
      contextTrafficServiceUrl: process.env.process.env.contextPathTrafStation '/station',
      resultSearchs : [],

      NUMBER_PAGE_MAX: 25,
      messages: [],

      displayedColumns: [
        {
          label: 'ID',
          field: 'id',
          hidden: true
          
        },
        {
          label: 'Station',
          field: 'station'
        },
        {
          label: 'Reseau',
          field: 'reseau'
        },
        {
          label: 'Traffic',
          field: 'traffic',
          type: 'number'
        },
        {
          label: 'Correspond',
          field: 'listCorrespondance'
        },{
          label: 'Ville',
          field: 'ville'
        },{
          label: 'Arrond',
          field: 'arrondissement',
          type: 'number'
        }
        
      ],

      listeReseauxDispo: [
        { key: '', value: '-------------' },
        { key: 'Metro', value: 'Metro' },
        { key: 'RER', value: 'RER' },
      ],

      onClickFn: function(row, index){
        this.$router.push('/selectStation/' + row.id)
      }


    }
  },
  computed: {

  },
  mounted () {

  },
  methods: {

    sub: function(event){
 
      axios.post(this.contextTrafficServiceUrl + '/findStationsByCrit',
        {
            'reseau' : this.reseau,
            'station': this.station,
            'trafficMin': this.trafficMin,
            'trafficMax': this.trafficMax,
            'ville': this.ville,
            'numberMaxElements': 3000,
            'page': 1


        },{
         headers: {
           'Content-Type': 'application/json',
        },
      })
      .then(response => {
        var data = response.data
        this.resultSearchs = data
        this.messages.length = 0;
        if (this.resultSearchs != null && this.resultSearchs.length === 100){
          this.messages.push('The search return too much elements.')
        }
       
      })
      .catch(e => {
        this.errors.push(e)
      })
      event.preventDefault();
    },


    createComponent : function(message) {
      this.$router.push('/createStation')
    },

   
  }
}
