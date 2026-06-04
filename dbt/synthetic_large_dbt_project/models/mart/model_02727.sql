{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02081') }},
        {{ ref('model_01970') }}
)
select id, 'model_02727' as name from sources
