{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01170') }},
        {{ ref('model_01472') }}
)
select id, 'model_02113' as name from sources
