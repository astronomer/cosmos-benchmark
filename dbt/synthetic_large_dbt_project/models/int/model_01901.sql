{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00914') }},
        {{ ref('model_00761') }},
        {{ ref('model_01155') }}
)
select id, 'model_01901' as name from sources
