{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02184') }},
        {{ ref('model_01685') }},
        {{ ref('model_01873') }}
)
select id, 'model_02413' as name from sources
