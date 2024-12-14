import axios from "axios"

axios.defaults.baseURL = "https://parallelum.com.br/fipe/api/v1"

const fetcher = (url: string) => axios.get(url).then((res) => res.data)
export default fetcher;