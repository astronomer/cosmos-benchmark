{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01514') }},
        {{ ref('model_01923') }},
        {{ ref('model_01609') }}
)
select id, 'model_02879' as name from sources
