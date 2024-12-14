import fetcher from "@/api/fetcher";
import FipeScreen from "@/components/FipeScreen";
import {Ano, FipeItem} from "@/models";
import {Text} from "react-native";
import useSWR from 'swr'
import {router, useLocalSearchParams} from 'expo-router';

export default function Anos() {
  const { codigoMarca, codigoModelo } = useLocalSearchParams();
  const { data, error, isLoading } = useSWR<Ano[]>("/carros/marcas/${codigoMarca}/modelos/${codigoModelo}/anos", fetcher, {
    dedupingInterval: 60_000
  })

  if (error) {
    return (<Text>{error.message}</Text>)
  }

  const handlePress = (item: FipeItem) => {
    const {codigo} = item;
    router.push({pathname: '/veiculo', params: {codigoMarca, codigoModelo, codigoAno: codigo}})
  }

  return (
    <FipeScreen data={data} handlePress={handlePress} isLoading={isLoading} />
  );
}