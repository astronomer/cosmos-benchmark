{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00364') }},
        {{ ref('model_00159') }},
        {{ ref('model_00109') }}
)
select id, 'model_01030' as name from sources
