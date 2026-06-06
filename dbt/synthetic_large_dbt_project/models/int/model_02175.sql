{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01426') }},
        {{ ref('model_01391') }},
        {{ ref('model_00786') }}
)
select id, 'model_02175' as name from sources
