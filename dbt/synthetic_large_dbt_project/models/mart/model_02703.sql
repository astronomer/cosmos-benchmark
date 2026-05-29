{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01689') }},
        {{ ref('model_02096') }},
        {{ ref('model_01923') }}
)
select id, 'model_02703' as name from sources
