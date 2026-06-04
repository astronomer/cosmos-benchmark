{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00297') }},
        {{ ref('model_00137') }},
        {{ ref('model_00475') }}
)
select id, 'model_00975' as name from sources
