// eslint-disable-next-line no-undef
exports.handler = async (event, context, callback) => {   
  console.log(' authorizer');
  console.log({ event });

  try {
    console.log(' authorizer end');
    const authorization = event.headers.Authorization
    console.log("authorization : " + authorization)

    // Remplissage utilisateur
    if ( authorization == "EAST" || authorization == "WEST"){
      callback(
        null,
        generatePolicy(
          { authorization },
          'Allow',
          event.methodArn
        )
      );
   }else{
      callback('Unauthorized');
   }


  } catch (error) {
    console.log({ error });
    callback('Unauthorized');
  }
};

const generatePolicy = (
  {authorization },
  effect,
  resource
) => {
  console.log(' generatePolicy ');
  let authResponse = {};

  authResponse.principalId = "user1";
 
  if (effect && resource && authorization) {
    let policyDocument = {};
    policyDocument.Version = '2012-10-17';
    policyDocument.Statement = [];
    var statementOne = {};
    statementOne.Action = 'execute-api:Invoke';
    statementOne.Effect = effect;
    statementOne.Resource = resource;
    policyDocument.Statement[0] = statementOne;
    authResponse.policyDocument = policyDocument;
  }

  
  return authResponse;
};


