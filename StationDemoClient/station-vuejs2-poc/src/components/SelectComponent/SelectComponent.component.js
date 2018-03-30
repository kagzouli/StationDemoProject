import axios from 'axios';

export default {
  name: 'select-component',
  components: {}, 
  props: [],
  
  data () {
    return {
      test: 'aaaa',
      contextTrafficServiceUrl: 'http://54.38.186.137:9080/StationDemoWeb/station',
      id: 0,
      reseau: '', 
      station: '',
      traffic: 0,
      correspondance: '',
      ville: '',
      arrondissement: 0,
      displayArron: true,
    }
  },
  computed: {

  },


  mounted: function () {
        this.id = this.$route.params.id,
        this.selectStation();
  },
  methods: {
     selectStation: function(id){
      const relativeUrl = '/findStationById/' + this.id;

      axios.get(this.contextTrafficServiceUrl + relativeUrl,
      {
      },{
       headers: {
         'Content-Type': 'application/x-www-form-urlencoded',
      },
    })
    .then(response => {
      var data = response.data
      this.id = data.id
	    this.reseau = data.reseau
      this.station = data.station
      this.traffic = data.traffic
      if (data.listCorrespondance != null){
          this.correspondance = data.listCorrespondance.toString()
      }
     
      this.ville= data.ville
      this.arrondissement = data.arrondissement
    })
    .catch(e => {
      this.errors.push(e)
    })
   },

   sub: function(event){

      var params = '?newTraffic=' + this.traffic + '&newCorr=' 

      if (this.correspondance != null && this.correspondance != ''){
           params = params +  this.correspondance .split(',')     
      }

      axios.patch(this.contextTrafficServiceUrl + '/updateStation/' + this.id + params, {},
      {
         headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      })
     .then(response => {
       var data = response.data
       var success = data.success;
       if (success){
        window.alert('The station ' +this.station+ ' has been updated  with success')
        this.$router.push("/")   
       }else{
         let messageError = data.errors[0];
         window.alert('Error --> ' + messageError);
       }
      
     })
     .catch(e => {
       this.errors.push(e)
     })

     event.preventDefault();
   },
   
   deleteStation : function(){
    if (confirm("Are you sure to delete  the station '" + this.station + "'?")) {
      axios.delete(this.contextTrafficServiceUrl + '/deleteStation/' + this.id,
      {},{
       headers: {
         'Content-Type': 'application/json',
      },
    })
    .then(response => {
      var data = response.data
      var success = data.success;
      if (success){
        window.alert('The station has been delete with success');
        this.$router.push("/")     
      }else{
        let messageError = data.errors[0];
        window.alert('Error --> ' + messageError);
      }
     
    })
    .catch(e => {
      this.errors.push(e)
    })
    }
   }
  }
}
