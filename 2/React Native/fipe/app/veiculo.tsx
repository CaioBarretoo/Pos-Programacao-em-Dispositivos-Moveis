import fetcher from "@/api/fetcher";
import {DetalheVeiculo} from "@/models";
import {Text, View} from "react-native";
import useSWR from 'swr'
import {router, useLocalSearchParams} from 'expo-router';
import styles from "@/styles";
import SuperButton from "@/components/SuperButton";

export default function Veiculo() {
  const {codigoMarca, codigoModelo, codigoAno} = useLocalSearchParams();
  const {data: veiculo, error, isLoading} = useSWR<DetalheVeiculo>("/carros/marcas/${codigoMarca}/modelos/${codigoModelo}/anos/${codigoAno}", fetcher, {
    dedupingInterval: 60_000
  })

  if (error) {
    return (<Text>{error.message}</Text>)
  }

  const detailItem = (item: string) => {
    return (
      <View style={styles.item}>
        <Text style={styles.textDetail}>{item}</Text>
      </View>
    )
  }

  const goBack = () => {
    router.dismissAll()
  }

  return (
    <View style={styles.container}>
      {detailItem("Veiculo: ${veiculo?.Modelo}")}
      {detailItem("Marca: ${veiculo?.Marca}")}
      {detailItem("Valor: ${veiculo?.Valor}")}
      {detailItem("Ano do modelo: ${veiculo?.AnoModelo}")}
      {detailItem("Combustivel: ${veiculo?.Combustivel}")}
      <SuperButton title="Voltar Home" onPress={goBack} />
    </View>
  );
}