{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01165') }},
        {{ ref('model_01343') }}
)
select id, 'model_01654' as name from sources
