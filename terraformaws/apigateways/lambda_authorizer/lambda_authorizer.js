// eslint-disable-next-line no-undef
exports.handler = async (event, context, callback) => {   
  console.log(' authorizer');
  console.log({ event });

  try {
    console.log(' authorizer end');
    callback(
      null,
      generatePolicy(
        {  },
        'Allow',
        event.methodArn
      )
    );


  } catch (error) {
    console.log({ error });
    callback('Unauthorized');
  }
};

const generatePolicy = (
  { },
  effect,
  resource
) => {
  console.log(' generatePolicy ');
  let authResponse = {};

  authResponse.principalId = "user1";
  return authResponse;
};


