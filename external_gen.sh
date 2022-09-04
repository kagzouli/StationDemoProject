sudo kubectl get secret awssm-secret -n default
EXEC_GET_SECRETMANAGER="$?"
echo "Resultat get secret manager : ${EXEC_GET_SECRETMANAGER}"
if [ "${EXEC_GET_SECRETMANAGER}" -ne 0 ]; then
        echo "Creation generic secret"
        exit 1;
else
   echo "Generic secret already exists"
fi

