import axios from 'axios';

export default {
  name: 'create-component',
  components: {}, 
  props: [],
  data () {
    return {

      reseau: '', 
      station: '',
      traffic: '',
      correspondance: '',
      ville: '',
      arrondissement: '',
      contextTrafficServiceUrl: 'http://54.38.186.137:9080/StationDemoWeb/station',
      errors: [] = {},
      displayArron: false,
      listeReseauxDispo: [
        { key: '', value: '-------------' },
        { key: 'Metro', value: 'Metro' },
        { key: 'RER', value: 'RER' },
      ]

    }
  },
  computed: {

  },
  mounted () {

  },
  methods: {

    sub: function(event){
      axios.put(this.contextTrafficServiceUrl + '/insertStation',
      {
          'reseau' : this.reseau,
          'station': this.station,
          'traffic': this.traffic,
          'listCorrespondance': this.correspondance.split(','),
          'ville': this.ville,
          'arrondissement': this.arrondissement
      },{
       headers: {
         'Content-Type': 'application/json',
      },
    })
    .then(response => {
      var data = response.data
      var success = data.success;
      if (success){
        alert("The station has been inserted with success")
        this.$router.push("/")
      }else{
        // On met les erreurs a vide.
        this.errors.length = 0;
        this.errors = data.errors;
      }
     
    })
    .catch(e => {
      this.errors.push(e)
    })

    event.preventDefault();
  },

  changeVille: function(){
    var villeUpperCase =  this.ville.toUpperCase();
    this.displayArron =  (villeUpperCase == 'PARIS' || villeUpperCase == 'LYON' || villeUpperCase == 'TOULOUSE' || villeUpperCase == 'MARSEILLE');
  }

 }

 
}
