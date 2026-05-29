{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00229') }},
        {{ ref('model_00021') }},
        {{ ref('model_00023') }}
)
select id, 'model_01455' as name from sources
