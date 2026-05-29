{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00584') }},
        {{ ref('model_00184') }},
        {{ ref('model_00426') }}
)
select id, 'model_01479' as name from sources
