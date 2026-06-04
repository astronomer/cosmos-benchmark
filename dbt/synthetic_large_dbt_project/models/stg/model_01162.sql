{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00729') }},
        {{ ref('model_00206') }},
        {{ ref('model_00465') }}
)
select id, 'model_01162' as name from sources
