import fetcher from "@/api/fetcher";
import FipeScreen from "@/components/FipeScreen";
import {FipeItem, Marca} from "@/models";
import {Text} from "react-native";
import useSWR, {mutate} from "swr";
import {router} from "expo-router";

export default function Index(){
  const {data, error, isLoading, mutate} = useSWR<Marca[]>("/carros/marcas", fetcher, {
    dedupingInterval: 60_000
  })
  
  if(error){
    return(<Text>{error.message}</Text>)
  }

  const handlePress = (item: FipeItem) => {
    router.push({pathname: '/modelos', params: {codigoMarca: item.codigo}})
  }
  return (
    <FipeScreen data={data} handlePress={handlePress} isLoading={isLoading} update={mutate}/>
  );
}
