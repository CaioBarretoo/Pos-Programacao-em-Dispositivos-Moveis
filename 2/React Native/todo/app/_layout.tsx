import { Stack } from "expo-router";
import { theme } from '@/components/styles'

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{
        title: "Lista de compras",
        headerTintColor: theme.tint,
        headerStyle: {
          backgroundColor: theme.header,
        }
      }}></Stack.Screen>

    </Stack>
  )

}