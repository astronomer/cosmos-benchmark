{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00324') }},
        {{ ref('model_00352') }},
        {{ ref('model_00151') }}
)
select id, 'model_01341' as name from sources
