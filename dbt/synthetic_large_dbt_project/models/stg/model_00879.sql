{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00313') }},
        {{ ref('model_00171') }},
        {{ ref('model_00066') }}
)
select id, 'model_00879' as name from sources
