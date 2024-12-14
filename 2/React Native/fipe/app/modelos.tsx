import fetcher from "@/api/fetcher";
import FipeScreen from "@/components/FipeScreen";
import {FipeItem, ListaModelos} from "@/models";
import {Text} from "react-native";
import useSWR from 'swr'
import {router, useLocalSearchParams} from 'expo-router';

export default function Modelos() {
  const { codigoMarca } = useLocalSearchParams();
  const { data, error, isLoading } = useSWR<ListaModelos>(`/carros/marcas/${codigoMarca}/modelos`, fetcher, {
    dedupingInterval: 60_000
  })

  if (error) {
    return (<Text>{error.message}</Text>)
  }

  const handlePress = (item: FipeItem) => {
    const {codigo} = item;
    router.push({pathname: '/anos', params: {codigoMarca: codigoMarca, codigoModelo: codigo}})
  }

  return (
    <FipeScreen data={data?.modelos} handlePress={handlePress} isLoading={isLoading} />
  );
}
