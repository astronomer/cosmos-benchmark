{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01324') }},
        {{ ref('model_01410') }}
)
select id, 'model_01566' as name from sources
